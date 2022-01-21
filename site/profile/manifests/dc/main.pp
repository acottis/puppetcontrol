# Creates a Domain Controller,
# TODO: Make it a member if it detects another DC active
class profile::dc::main (
  String $password = 'SafeM0d3!',
  String $domain = 'gala.xy',
) {
  dsc { 'Install AD-Domain-Services':
    resource_name => 'WindowsFeature',
    module        => 'PSDesiredStateConfiguration',
    properties    => {
      ensure => 'Present',
      name   => 'AD-Domain-Services',
    }
  }

  Exec { 'Install PS Provider Nuget':
    onlyif   => 'if((Get-PackageProvider | Where-Object name -eq "Nuget" )) { exit 1 }',
    command  => 'Install-PackageProvider -Name NuGet -Force; if(!(Get-PackageProvider -Name Nuget)) { exit 1 }',
    provider => 'powershell',
  }

  Exec { 'Install PSModule xActiveDirectory':
    onlyif   => 'if(Get-module -ListAvailable -Name xActiveDirectory) { exit 1 }',
    command  => 'Install-Module -Name xActiveDirectory -Force; if(!(Get-module -ListAvailable -Name xActiveDirectory)) { exit 1 }',
    provider => 'powershell',
    require  => Exec['Install PS Provider Nuget']
  }

  dsc {'Promote to AD':
    module        => 'xActiveDirectory',
    resource_name => 'xADDomain',
    require       => Exec['Install PSModule xActiveDirectory'],
    properties    => {
      domainName                    => 'gala.xy',
      domainAdministratorCredential => {
        dsc_type       => 'MSFT_Credential',
        dsc_properties => {
            user     => 'dummy',
            password => $password,
        }
      },
      safemodeAdministratorPassword => {
        dsc_type       => 'MSFT_Credential',
        dsc_properties => {
            user     => 'dummy',
            password => $password,
        }
      }
    }
  }
}
