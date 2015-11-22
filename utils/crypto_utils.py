from Crypto.Hash import SHA256
from Crypto.PublicKey import RSA
from Crypto.Signature import PKCS1_v1_5
from base64 import b64encode

import os.path


def init_keys():
    """
    Initilize keys from here, device name exists in the 'name'. Verify
    weather name file exists. If not exits we have to generate keys. We are
    storing keys in .keys directory in project root
    """
    def init_dirs(senzy_name):
        """
        Create .keys directory and name file if not exits
        """
        if not os.path.exists('.keys/name'):
            # first we have to create .keys/ directory if not exists
            try:
                os.makedirs('.keys')
            except OSError:
                print('keys exists')

            # create name file from here
            senzy_name_file = open('.keys/name', 'w')
            senzy_name_file.write(senzy_name)
            senzy_name_file.close()
        else:
            print('keys exists')

    def save_key(file_name, key):
        """
        Save key in .pem file
        """
        key_file = open('.keys/' + file_name, 'w')
        key_file.write(key)
        key_file.close()

    # TODO read senzy name from config file
    senzy_name = 'test'
    init_dirs(senzy_name)

    # generate keys
    key_pair = RSA.generate(1024, e=65537)
    public_key = key_pair.publickey().exportKey("PEM")
    private_key = key_pair.exportKey("PEM")

    # save keys in pem file
    save_key('publicKey.pem', public_key)
    save_key('privateKey.pem', private_key)


def get_pubkey():
    """
    Reads a public key from the file
    return: Base64 encoded public key
    """
    pubkey = open('.keys/publicKey.pem', "r").read()

    return b64encode(pubkey)


def sign_senz(senz):
    """
    Sign senz with private key
    """
    # load private key
    key = open('.keys/privateKey.pem', "r").read()
    rsakey = RSA.importKey(key)

    # sign senz
    signer = PKCS1_v1_5.new(rsakey)
    digest = SHA256.new("".join(senz.split()))
    signature = signer.sign(digest)
    signed_senz = "%s %s" % (senz, b64encode(signature))

    return signed_senz
