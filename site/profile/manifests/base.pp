class profile::base ()
{

  file { 'C:\\Windows\\System32\\oemlogo.bmp':
    ensure => file,
    source => 'https://styles.redditmedia.com/t5_2oczgo/styles/communityIcon_h3k5uf2rhpz41.png',
    # source => 'puppet:///modules/oemlogo.bmp',
  }
  include chocolatey
  package { 'vscode.install':
    ensure           => latest,
    package_settings => {'confirm' => true},
    provider         => 'chocolatey',
    install_options  => ['-y'],
  }
}
