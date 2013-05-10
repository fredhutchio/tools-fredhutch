import json
from galaxy.datatypes.data import Text
from galaxy.datatypes.images import Html

class Jplace(Text):
    file_ext = "jplace"

    def sniff(self, filename):
        try:
            with open(filename, "r") as f:
                data = json.load(f)
                if all (k in data for k in ("version", "tree", "placements", "fields")):
                    return True
        except:
            pass

        return False

    def get_mime(self):
        return "application/json"

class AutoPrimaryComposite(Html):
    composite_type = "auto_primary_file"

    def __init__(self, **kwd):
        Html.__init__(self, **kwd)

    def regenerate_primary_file(self,dataset):
        """
        cannot do this until we are setting metadata
        """
        bn = dataset.metadata.base_name
        efp = dataset.extra_files_path
        flist = os.listdir(efp)
        rval = ['<html><head><title>Files for Composite Dataset %s</title></head><body><p/>Composite %s contains:<p/><ul>' % (dataset.name,dataset.name)]
        for i,fname in enumerate(flist):
            sfname = os.path.split(fname)[-1]
            f,e = os.path.splitext(fname)
            rval.append( '<li><a href="%s">%s</a></li>' % ( sfname, sfname) )
        rval.append( '</ul></body></html>' )
        f = file(dataset.file_name,'w')
        f.write("\n".join( rval ))
        f.write('\n')
        f.close()

    def set_meta(self, dataset, **kwd):
        Html.set_meta(self, dataset, **kwd)
        self.regenerate_primary_file(dataset)

    def get_mime(self):
        return "text/html"

class BasicHtmlComposite(Html):
    composite_type = "basic"
