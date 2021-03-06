# == Class: st2::profile::enterprise_auth_backend_ldap
#
#  Profile to install StackStorm Enterprise Auth Backends. This feature is
#  currently under active development, and limited to early access users.
#  If you would like to try this out, please send an email to support@stackstorm.com
#  and let us know!
#
# === Parameters
#
#  [*version*]      - Version of StackStorm Auth Backend to install
#
# === Variables
#
#  This class has no variables
#
# === Examples
#
#  include ::profile::enterprise_auth_backend
#
class profile::enterprise_auth_backend_ldap(
  $version = '0.1.0',
) inherits st2 {

  $_access_key = hiera('aws::access_key', undef)
  $_secret_key = hiera('aws::secret_access_key', undef)

  if $_access_key and $_secret_key {
    if !defined(Class['s3cmd']){
      class {'s3cmd':
        aws_access_key => $_access_key,
        aws_secret_key => $_secret_key,
        gpg_passphrase => fqdn_rand_string(32),
        owner          => 'root',
      }
    }
    s3cmd::commands::get { "/tmp/st2_enterprise_auth_backend_ldap-${version}-py2.7.egg":
      s3_object => "s3://st2enterprise/st2_enterprise_auth_backend_ldap-${version}-py2.7.egg",
      cwd       => '/tmp',
      owner     => 'root',
      require   => Class['s3cmd'],
    }
  }
  
  exec { 'install auth backend':
    command => "easy_install /tmp/st2_enterprise_auth_backend_ldap-${version}-py2.7.egg",
    path    => '/usr/bin:/usr/sbin:/bin:/sbin',
    require => S3cmd::Commands::Get["/tmp/st2_enterprise_auth_backend_ldap-${version}-py2.7.egg"]
  }

}
