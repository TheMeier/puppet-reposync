define reposync::syncrepo(
  $target_base  = "${reposync::params::target_base}",
  $target       = $name,
  $day          = absent,
  $hour         = '8',
  $minute       = '0',
  $ensure       = 'present',
  $user         = 'root',
) {

 if ! defined(Class['reposync']) {
    fail('You must include the reposync base class before using any reposync defined resources')
  }
	validate_absolute_path($target_base)


	$cron_name   = "reposync-${name}"
	$log_path    = "${::reposync::params::log_directory}/reposync-${name}.log"
	$script_path = "${::reposync::params::script_directory}/reposync-${name}.sh"
  $lockfile    = "${::reposync::params::lockdir}/reposync-${name}.lock"

	case $ensure {
		'present': {
			file{$script_path:
				ensure  => present,
				mode    => '0755',
				content => 
"#This file is managed by puppet.
/usr/bin/flock -x '$lockfile' /usr/bin/reposync --norepopath -r '${title}' -p '${target_base}/${target}' >> '${log_path}'
/usr/bin/flock -x '$lockfile' /usr/bin/createrepo '${target_base}/${target}' >> '${log_path}'
/usr/bin/rm '$lockfile'
"				
			}

			cron{ $cron_name:
				ensure  => present,
				command => $script_path,
				user    => $user,
				weekday => $day,
				hour    => $hour,
				minute  => $minute
			}

		}
		'absent': {
			cron{ $cron_name:
				ensure => absent
			}
			file{ $script_path:
				ensure => absent
			}
		}
	} 


}
