class reposync::logrotate (
) inherits reposync::params {

  logrotate::file { 'reposync':
    log         => '/var/log/reposync/*log',
    options     => ['compress', 'delaycompress', 'dateext', 'missingok', 'sharedscripts', 'daily', "rotate ${reposync::params::logrotate_days}"],
  }


}
