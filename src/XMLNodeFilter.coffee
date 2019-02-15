
# Represents a node filter
module.exports = class XMLNodeFilter

  FilterAccept : 1
  FilterReject : 2
  FilterSkip : 3

  ShowAll : 0xffffffff
  ShowElement : 0x1
  ShowAttribute : 0x2
  ShowText : 0x4
  ShowCDataSection : 0x8
  ShowEntityReference : 0x10
  ShowEntity : 0x20
  ShowProcessingInstruction : 0x40
  ShowComment : 0x80
  ShowDocument : 0x100
  ShowDocumentType : 0x200
  ShowDocumentFragment : 0x400
  ShowNotation : 0x800


  # DOM level 4 functions to be implemented later
  acceptNode: (node) -> throw new Error "This DOM method is not implemented."
