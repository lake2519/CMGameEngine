#include<hgl/audio/AudioScene.h>
#include<hgl/audio/AudioSource.h>
#include<hgl/audio/Listener.h>
#include<hgl/al/al.h>
namespace hgl
{
	/**
     * 計算指定音源相對收聽者的音量
     */
	const double GetGain(AudioListener *l,AudioSourceItem *s)
    {
        if(!l||!s)return(0);

        if(s->gain<=0)return(0);        //本声音量就是0

        float ref_dist,max_dist,distance;

        const Vector3f &        lpos=l->GetPosition();

        distance=length(lpos,s->cur_pos);

        if(s->distance_model==AL_INVERSE_DISTANCE_CLAMPED||s->distance_model==AL_INVERSE_DISTANCE)
        {
            if(s->distance_model==AL_INVERSE_DISTANCE_CLAMPED)
                if(distance<=s->ref_distance)
                    return 1;

            distance = hgl_max(distance,s->ref_distance);
            distance = hgl_min(distance,s->max_distance);

            return s->ref_distance/(s->ref_distance+s->rolloff_factor*(distance-s->ref_distance));
        }
        else
        if(s->distance_model==AL_LINEAR_DISTANCE_CLAMPED)
        {
            distance = hgl_max(distance,s->ref_distance);
            distance = hgl_min(distance,s->max_distance);

            return (1-s->rolloff_factor*(distance-s->ref_distance)/(s->max_distance-s->ref_distance));
        }
        else
        if(s->distance_model==AL_LINEAR_DISTANCE)
        {
            distance = hgl_min(distance,s->max_distance);
            return (1-s->rolloff_factor*(distance-s->ref_distance)/(s->max_distance-s->ref_distance));
        }
        if(s->distance_model==AL_EXPONENT_DISTANCE)
        {
            return pow(distance/s->ref_distance,-s->rolloff_factor);
        }
        else
        if(s->distance_model==AL_EXPONENT_DISTANCE_CLAMPED)
        {
            distance = hgl_max(distance,s->ref_distance);
            distance = hgl_min(distance,s->max_distance);

            return pow(distance/s->ref_distance,-s->rolloff_factor);
        }
        else
            return 1;
    }

    /**
     * 音频场景管理类构造函数
     * @param max_source 最大音源数量
     * @param al 收的者
     */
    AudioScene::AudioScene(int max_source,AudioListener *al)
    {
        source_pool.PreMalloc(max_source);

        listener=al;
    }

    AudioSourceItem *AudioScene::Create(AudioBuffer *buf,const Vector3f &pos,const float &gain)
    {
        if(!buf)
            return(nullptr);

        AudioSourceItem *asi=new AudioSourceItem;

        asi->buffer=buf;

        asi->loop=false;

        asi->gain=gain;

        asi->distance_model=AL_INVERSE_DISTANCE_CLAMPED;

        asi->last_pos=pos;
        asi->cur_pos=pos;

        asi->last_time=asi->cur_time=0;
        asi->move_speed=0;

        asi->last_gain=gain*GetGain(listener,asi);

        return asi;
    }

    void AudioScene::Delete(AudioSourceItem *asi)
    {
        if(!asi)return;

        source_list.DeleteByData(asi);
    //    source_link.
    }

    bool AudioScene::ToMute(AudioSourceItem *asi)
    {

    }

    bool AudioScene::ToHear(AudioSourceItem *asi)
    {
    }

    /**
     * 刷新處理
     * @return 收聽者仍可聽到的音源數量
     * @return -1 出錯
     */
    int AudioScene::Update()
    {
        if(!listener)return(-1);

        const int count=source_list.GetCount();

        if(count<=0)return 0;

        float new_gain;
        int hear_count=0;

        AudioSourceItem **ptr=source_list.GetData();

        for(int i=0;i<count;i++)
        {
            new_gain=OnCheckGain(*ptr);

            if(new_gain<=0)                 //听不到声音了
            {
                if((*ptr)->last_gain>0)
                {
                    ToMute(*ptr);
                    OnMute(*ptr);           //之前可以听到
                }
                else
                    OnContinuedMute(*ptr);  //之前就听不到
            }
            else
            {
                if((*ptr)->last_gain<=0)
                {
                    if(ToHear(*ptr))
                        OnHear(*ptr);       //之前没声
                    else
                        new_gain=0;         //没有足够可用音源，所以还是听不到
                }
                else
                    OnContinuedHear(*ptr);  //之前就有声音
            }

            (*ptr)->last_gain=new_gain;

            if(new_gain>0)
                ++hear_count;

            ++ptr;
        }

        return hear_count;
    }
}//namespace hgl