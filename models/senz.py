class Senz(object):
    """
    Keep senz message attributes in here
    """
    def __init__(self, type=None, sender=None, receiver=None, attributes={},
                 signature=None):
        """
        Senz object contains
            1. Type
            2. attributes
            3. sender
            4. receiver
            5. signature
        """
        self.type = type
        self.sender = sender
        self.receiver = receiver
        self.attributes = attributes
        self.signature = signature
