input_config_dict = {'inputs': [{'input_type': 'looped_file',
             'media_type': 'video',
             'name': 'BigBuckBunny.mp4'},
            {'input_type': 'looped_file',
             'media_type': 'audio',
             'name': 'BigBuckBunny.mp4'}]}

pipeline_config_dict = {'audio_codecs': ['aac'],
 'availability_window': 300,
 'channels': 2,
 'manifest_format': ['dash', 'hls'],
 'presentation_delay': 30,
 'resolutions': ['720p', '480p'],
 'segment_size': 4,
 'streaming_mode': 'live',
 'update_period': 8,
 'video_codecs': ['h264']}