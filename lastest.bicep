
@description('Name of the CDN Profile')
param profileName string = 'cdn-frontdoorprofile-sbx'

@description('Name of the CDN Endpoint, must be unique')
param endpointName string = 'cnd-appendpoint-sbx'

@description('Url of the origin')
param originUrl string = 'mango-field-06f7e1603.1.azurestaticapps.net'

@description('Name of the App Service Web App')
param webAppName string = 'app-p3dspc01-sbx'

@description('CDN SKU names')
@allowed([
  'Standard_Akamai'
  'Standard_Microsoft'
  'Standard_Verizon'
  'Premium_Verizon'
])
param CDNSku string = 'Standard_Microsoft'

@description('Location for all resources.')
param location string = resourceGroup().location

resource webAppName_resource 'Microsoft.Web/staticSites@2021-03-01' = {
  name: webAppName
  location: location
  sku: {
    name: 'Standard'
    tier: 'Standard'
  }
  properties: {
    stagingEnvironmentPolicy: 'Enabled'
    allowConfigFileUpdates: true
    provider: 'None'
    enterpriseGradeCdnStatus: 'Disabled'
  }
}

resource profile 'Microsoft.Cdn/profiles@2021-06-01' = {
  name: profileName
  location: 'Global'
  sku: {
    name: CDNSku
  }
}


resource endpoint 'Microsoft.Cdn/profiles/endpoints@2021-06-01' = {
  parent: profile
  name: endpointName
  location: 'Global'
  properties: {
    originHostHeader: originUrl
    isHttpAllowed: true
    isHttpsAllowed: true
    queryStringCachingBehavior: 'UseQueryString'
    contentTypesToCompress: [
      'application/eot'
      'application/font'
      'application/font-sfnt'
      'application/javascript'
      'application/json'
      'application/opentype'
      'application/otf'
      'application/pkcs7-mime'
      'application/truetype'
      'application/ttf'
      'application/vnd.ms-fontobject'
      'application/xhtml+xml'
      'application/xml'
      'application/xml+rss'
      'application/x-font-opentype'
      'application/x-font-truetype'
      'application/x-font-ttf'
      'application/x-httpd-cgi'
      'application/x-javascript'
      'application/x-mpegurl'
      'application/x-opentype'
      'application/x-otf'
      'application/x-perl'
      'application/x-ttf'
      'font/eot'
      'font/ttf'
      'font/otf'
      'font/opentype'
      'image/svg+xml'
      'text/css'
      'text/csv'
      'text/html'
      'text/javascript'
      'text/js'
      'text/plain'
      'text/richtext'
      'text/tab-separated-values'
      'text/xml'
      'text/x-script'
      'text/x-component'
      'text/x-java-source'
    ]
    isCompressionEnabled: true
    origins: [
      {
        name: 'origin1'
        properties: {
          hostName: originUrl
          httpPort: 80
          httpsPort: 443
          originHostHeader: originUrl
          priority: 1
          weight: 1000
          enabled: true
        }
      }
    ]
  }
}




@description('Specifies the name of the Azure Storage account.')
param storageAccountName string = 'stp3dspc01sbx'

@description('Specifies the name of the blob container.')
param containerName string = 'sandbox'

@description('specify CDN endpoint for storage account')
param storageendpoint string = 'cdn-stendpoint-sbx'

resource sa 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_RAGRS'
    tier: 'Standard'
  }
  kind: 'StorageV2'
  properties: {
    defaultToOAuthAuthentication: false
    publicNetworkAccess: 'Enabled'
    allowCrossTenantReplication: true
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: true
    allowSharedKeyAccess: true
    networkAcls: {
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      requireInfrastructureEncryption: false
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Hot'
  }
}
  
resource storageAccounts_blobs 'Microsoft.Storage/storageAccounts/blobServices@2021-09-01' = {
  parent: sa
  name: 'default'
  sku: {
    name: 'Standard_RAGRS'
    tier: 'Standard'
  }
  properties: {
    cors: {
      corsRules: []
    }
    deleteRetentionPolicy: {
      allowPermanentDelete: false
      enabled: true
      days: 7
    }
    isVersioningEnabled: false
    changeFeed: {
      enabled: false
    }
    restorePolicy: {
      enabled: false
    }
    containerDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
  }
}

resource storageAccounts_fileServices 'Microsoft.Storage/storageAccounts/fileServices@2021-09-01' = {
  parent: sa
  name: 'default'
  sku: {
    name: 'Standard_RAGRS'
    tier: 'Standard'
  }
  properties: {
    cors: {
      corsRules: []
    }
    shareDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
  }
}

resource torageAccounts_queueServices 'Microsoft.Storage/storageAccounts/queueServices@2021-09-01' = {
  parent: sa
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource storageAccounts_tableServices 'Microsoft.Storage/storageAccounts/tableServices@2021-09-01' = {
  parent: sa
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}


resource endpoint1 'Microsoft.Cdn/profiles/endpoints@2021-06-01' = {
  parent: profile
  name: storageendpoint
  location: 'Global'
  properties: {

    originHostHeader: 'stp3dspc01sbx.blob.core.windows.net'
    contentTypesToCompress: [
      'application/eot'
      'application/font'
      'application/font-sfnt'
      'application/javascript'
      'application/json'
      'application/opentype'
      'application/otf'
      'application/pkcs7-mime'
      'application/truetype'
      'application/ttf'
      'application/vnd.ms-fontobject'
      'application/xhtml+xml'
      'application/xml'
      'application/xml+rss'
      'application/x-font-opentype'
      'application/x-font-truetype'
      'application/x-font-ttf'
      'application/x-httpd-cgi'
      'application/x-javascript'
      'application/x-mpegurl'
      'application/x-opentype'
      'application/x-otf'
      'application/x-perl'
      'application/x-ttf'
      'font/eot'
      'font/ttf'
      'font/otf'
      'font/opentype'
      'image/svg+xml'
      'text/css'
      'text/csv'
      'text/html'
      'text/javascript'
      'text/js'
      'text/plain'
      'text/richtext'
      'text/tab-separated-values'
      'text/xml'
      'text/x-script'
      'text/x-component'
      'text/x-java-source'
    ]
    isCompressionEnabled: true
    isHttpAllowed: true
    isHttpsAllowed: true
    queryStringCachingBehavior: 'UseQueryString'
    origins: [
      {
        name: 'origin2'
        properties: {
          hostName: 'stp3dspc01sbx.blob.core.windows.net'
          httpPort: 80
          httpsPort: 443
          originHostHeader: 'stp3dspc01sbx.blob.core.windows.net'
          priority: 1
          weight: 1000
          enabled: true
        }
      }
    ]
    originGroups: []
    geoFilters: []
  }
}


resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-06-01' = {
  name: '${sa.name}/default/${containerName}'
}


param keyvaultname string = 'kv-p3dspc01-sbx'

resource keyvaultname_resouce 'Microsoft.KeyVault/vaults@2021-11-01-preview' = {
  name: keyvaultname
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: 'edf964b9-7f24-47ba-bd54-5c40401a463d'
    accessPolicies: [
      {
      tenantId: 'edf964b9-7f24-47ba-bd54-5c40401a463d'
      objectId: 'e28f155c-40d2-435b-a879-f76b20acef6b'
      permissions: {
        keys: [
          'get'
          'list'
        ]
        secrets: [
          'get'
          'list'
        ]
        certificates: []
      }
      }
      {
      tenantId: 'edf964b9-7f24-47ba-bd54-5c40401a463d'
      objectId: 'c1ee95f6-5f6e-4550-9f9f-f6950e5c792f'
      permissions: {
        keys: [
          'get'
          'list'
          'update'
          'create'
          'import'
          'delete'
          'recover'
          'backup'
          'restore'
          'getrotationpolicy'
          'setrotationpolicy'
          'rotate'
        ]
        secrets: [
          'get'
          'list'
          'set'
          'delete'
          'recover'
          'backup'
          'restore'
        ]
        certificates: [
          'get'
          'list'
          'update'
          'create'
          'import'
          'delete'
          'recover'
          'backup'
          'restore'
          'managecontacts'
          'manageissuers'
          'getissuers'
          'listissuers'
          'setissuers'
          'deleteissuers'
        ]
      }
    }
  ]
  enabledForDeployment: false
  enabledForDiskEncryption: false
  enabledForTemplateDeployment: false
  enableSoftDelete: true
  softDeleteRetentionInDays: 90
  enableRbacAuthorization: false
  vaultUri: 'https://kv-p3dspc01-sbx.vault.azure.net/'
  provisioningState: 'Succeeded'
  publicNetworkAccess: 'Enabled'
}
}

