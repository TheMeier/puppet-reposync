# == Class: reposync
#
# Full description of class reposync here.
#
# === Parameters
#
# Document parameters here.
#
# [*log_directory*]
#  optional specify directory for logs 
#
# [*script_directory*]
#  optional specify directory for cron scripts 
#
# [*target_base*]
#  optional specify base directory under wich the repos will
#  be kept
# 
# [*logrotate_enabled*]
#  enable/disable logrotate 


class reposync (
  $log_directory      = $reposync::params::log_directory,
  $script_directory   = $reposync::params::script_directory,
  $target_base        = $reposync::params::target_base,
  $logrotate_enabled  = $reposync::params::logrotate_enabled,

) inherits reposync::params {
	case $::osfamily {
		'RedHat': {
			$packages = ['yum-utils', 'createrepo']
		}
		default: {
			fail("'${::osfamily}' is not supported.")
		}
	}

  if $logrotate_enabled {
    class {'::reposync::logrotate': }
  }

	package{$packages:
		ensure => installed
	}

	file{$log_directory:
		alias  => 'reposync-logs',
		ensure => directory
	}

	file{$script_directory:
		alias  => 'reposync-scripts',
		ensure => directory
	}

	file{ "${target_base}":
		alias  => 'reposync-targets',
		ensure => directory
	}

}
