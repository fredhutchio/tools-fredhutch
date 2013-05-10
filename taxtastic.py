import os
import zipfile
from galaxy.datatypes.binary import Binary
from galaxy.datatypes.data import Text

class Refpkg(Text):
    composite_type = "basic"

    def __init__(self, **kwd):
        Text.__init__(self, **kwd)
        self.add_composite_file("CONTENTS.json")

    def get_mime(self):
        return "application/json"

class RefpkgZip(Binary):
    file_ext = "refpkg.zip"

    def __init__(self, **kwd):
        Binary.__init__(self, **kwd)

    def sniff(self, filename):
        if not zipfile.is_zipfile(filename):
            return False
        contains_contents_file = False
        zip_file = zipfile.ZipFile(filename, "r")
        for name in zip_file.namelist():
            if os.path.basename(name) == "CONTENTS.json":
                contains_contents_file = True
                break
        zip_file.close()
        if not contains_contents_file:
            return False
        return True

    def get_mime(self):
        return "application/zip"

Binary.register_sniffable_binary_format("refpkg.zip", "refpkg.zip", RefpkgZip)
