class profile::python {
  include ::st2::profile::python

  file { '/etc/facter/facts.d/pip_upgrade_20150902.txt':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => 'pip_upgrade_20150902=true',
    notify  => Exec['update-pip'],
  }

  exec { 'update-pip':
    command     => 'pip install -U pip',
    path        => '/usr/sbin:/usr/bin:/sbin:/bin',
    refreshonly => true,
  }

  Exec['update-pip'] -> Python::Pip<||>

}
