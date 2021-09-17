
import json

from azure.identity import ClientSecretCredential
from azure.keyvault.secrets import SecretClient

# load access credentials (from service principal)
CREDENTIALS_FILE = '/home/.azure/.tenant-credentials'
with open(CREDENTIALS_FILE, 'r') as stream:
    CREDENTIALS = json.loads(stream.read())

# connect to keyvault
keyvault_url = \
    'https://' \
    + CREDENTIALS['AZURE_KEYVAULT_NAME_USER'] \
    + '.vault.azure.net/'
kv_client = SecretClient(
    keyvault_url, 
    ClientSecretCredential(
        CREDENTIALS['AZURE_TENANT_ID'],
        CREDENTIALS['AZURE_CLIENT_ID'],
        CREDENTIALS['AZURE_CLIENT_SECRET']
    )
)

# read a secret
my_test_secret = kv_client.get_secret('MyTestSecret').value

print(my_test_secret)