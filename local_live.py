import streamer
from streamer import bitrate_configuration
import utils
import os
import time
import sys

def main():
    print('getcwd:      ', os.getcwd())
    print('__file__:    ', __file__)

    controller = streamer.controller_node.ControllerNode()
    output_dir = "local_playout_output_python"
    input_config_dict = utils.input_config_dict
    pipeline_config_dict = utils.pipeline_config_dict

    try:
        with controller.start(output_dir, input_config_dict, pipeline_config_dict, check_deps=False):
            # Sleep so long as the pipeline is still running.
            while True:
                status = controller.check_status()
                if status != streamer.node_base.ProcessStatus.Running:
                    return 0 if status == streamer.node_base.ProcessStatus.Finished else 1
                time.sleep(1)
    except (streamer.controller_node.VersionError,
            streamer.configuration.ConfigError,
            streamer.cloud_node.CloudAccessError) as e:
        # These are common errors meant to give the user specific, helpful
        # information.  Format these errors in a relatively friendly way, with no
        # backtrace or other Python-specific information.
        print('Fatal error:')
        print('  ' + str(e))

if __name__ == '__main__':
    sys.exit(main())