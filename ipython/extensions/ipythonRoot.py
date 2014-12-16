# ipythonRoot
"""Some helper functions to make Root in an ipython notebook easier to use."""

# See http://ipython.org/ipython-doc/stable/interactive/reference.html
# See IPython/core/magics/execution.py for an example
# and see IPython/core/interactiveShell.py for shell.ex

import tempfile

import ROOT
from ROOT import TCanvas

from IPython.core.magic import (Magics, magics_class, cell_magic)
from IPython.display import Image

__version__ = '0.0.1'

@magics_class
class RootMagics(Magics):
  """Magics related to Root.
    
    %%rootprint  - Capture Root stdout output and show in result cell
    %%rootplot   - Display a plot from Root in result cell
    """

  def __init__(self, shell):
    super(RootMagics, self).__init__(shell)

  @cell_magic
  def rootprint(self, line, cell):
    """Capture Root stdout output and print in ipython notebook."""
    
    with tempfile.NamedTemporaryFile() as tmpFile:      
      ROOT.gSystem.RedirectOutput(tmpFile.name, "w")
      self.shell.ex(cell)
      ROOT.gROOT.ProcessLine("gSystem->RedirectOutput(0);")
      print tmpFile.read()

  @cell_magic
  def rootplot(self, line, cell):
    """Display a plot from Root in ipython notebook."""

    with tempfile.NamedTemporaryFile(suffix='.png') as tmpFile:
      canvas = TCanvas("RootPlot", "RootPlot")
      self.shell.ex(cell)
      canvas.SaveAs(tmpFile.name)
      del canvas

      return Image(data=tmpFile.read(), format="png")

# Register
def load_ipython_extension(ipython):
  ipython.register_magics(RootMagics)