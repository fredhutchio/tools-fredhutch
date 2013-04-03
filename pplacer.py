import json
from galaxy.datatypes.data import Text

class Jplace(Text):
    file_ext = "jplace"

    def sniff(self, filename):
        try:
            with open(filename, 'r') as f:
                data = json.load(f)
                if all (k in data for k in ("version", "tree", "placements", "fields")):
                    return True
        except:
            pass

        return False
