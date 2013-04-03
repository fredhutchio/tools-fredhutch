import os
import zipfile
from galaxy.datatypes.binary import Binary
from galaxy.datatypes.data import Text

class Refpkg(Text):
    composite_type = 'auto_primary_file'

    def __init__(self, **kwd):
        Text.__init__(self, **kwd)
        self.add_composite_file('CONTENTS.json')

    def generate_primary_file( self, dataset = None ):
        rval = ['<html><head><title>taxtastic reference package</title></head><p/>']
        rval.append('<div>This composite dataset is composed of the following files:<p/><ul>')
        for composite_name, composite_file in self.get_composite_files( dataset = dataset ).iteritems():
            fn = composite_name
            opt_text = ''
            if composite_file.optional:
                opt_text = ' (optional)'
            if composite_file.get('description'):
                rval.append( '<li><a href="%s" type="application/binary">%s (%s)</a>%s</li>' % ( fn, fn, composite_file.get('description'), opt_text ) )
            else:
                rval.append( '<li><a href="%s" type="application/binary">%s</a>%s</li>' % ( fn, fn, opt_text ) )
        rval.append( '</ul></div></html>' )
        return "\n".join( rval )

class RefpkgZip(Binary):
    file_ext = "refpkg.zip"

    def __init__(self, **kwd):
        Binary.__init__(self, **kwd)

    def sniff(self, filename):
        if not zipfile.is_zipfile( filename ):
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
