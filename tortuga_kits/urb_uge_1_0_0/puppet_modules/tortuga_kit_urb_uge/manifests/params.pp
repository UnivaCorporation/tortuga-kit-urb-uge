#############################################################################
#
# This code is the Property, a Trade Secret and the Confidential Information
# of Univa Corporation.
#
# Copyright 2008-2018 Univa Corporation. All Rights Reserved. Access is Restricted.
#
# It is provided to you under the terms of the
# Univa Term Software License Agreement.
#
# If you have any questions, please contact our Support Department.
#
# http://www.univa.com
#
#############################################################################

class tortuga_kit_urb_uge::params {
  $urb_dist_file = "urb-3.1.1.tar.gz"
  $uge_user = 'sge'
  $uge_group = 'sge'
#  $uge_manager_user = 'sge',
  $uge_root = "/opt/uge"
  $uge_cell = "default"
  $python = "/usr/bin/python"
  $redis_port = "6380"
  $no_mongo = true
  # DefaultFrameworkConfig framework configuration options (in etc/urb.conf)
  $send_task_lost = true # required for Spark
  $job_submit_clear = false # required for UGE context variables to be passed
  $resource_mapping = 'hard' # recommended for Spark, can be 'hard', 'soft', or '' (empty string) 
#  $retrieve_from_web = true
}
