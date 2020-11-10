import streamer
from streamer import bitrate_configuration
import utils
import os

print('getcwd:      ', os.getcwd())
print('__file__:    ', __file__)

controller = streamer.controller_node.ControllerNode()
output_dir = "local_playout_output_python"
input_config_dict = utils.input_config_dict
pipeline_config_dict = utils.pipeline_config_dict
controller.start(output_dir, input_config_dict, pipeline_config_dict)