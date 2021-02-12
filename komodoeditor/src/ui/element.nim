import iup
import strformat

type
  InnerElement* = PIhandle

  Element* = ref object of RootObj
    inner: InnerElement
  
  ElementAttribute* = distinct string
  
  Callback* = proc (arg: InnerElement): CallbackCode {.cdecl.}
  
  CallbackCode* = cint

const
  AlignmentAttribute*: ElementAttribute = "ALIGNMENT".ElementAttribute
  GapAttribute*: ElementAttribute = "GAP".ElementAttribute
  MarginAttribute*: ElementAttribute = "MARGIN".ElementAttribute
  TitleAttribute*: ElementAttribute = "TITLE".ElementAttribute

const
  CloseCallbackCode*: CallbackCode = IUP_CLOSE.CallbackCode
  ContinueCallbackCode*: CallbackCode = IUP_CONTINUE.CallbackCode
  DefaultCallbackCode*: CallbackCode = IUP_DEFAULT.CallbackCode

func `inner=`*(self: Element; value: InnerElement) = self.inner = value
func inner*(self: Element): InnerElement = self.inner

func addChild*(self: Element; child: Element) =
  self.inner.append(child.inner)

func removeChild*(self: Element; child: Element) =
  child.inner.detach()

func setAttribute*[T: Element](self: T; attribute: ElementAttribute; value: string) =
  self.inner.setAttribute(attribute.string, value)

func setAttribute*[T: Element](self: T; attribute: ElementAttribute; value: int) =
  self.inner.setAttribute(attribute.string, $value)

func `[]=`*(self: Element; attribute: ElementAttribute; value: string) =
  self.setAttribute(attribute, value)

func `[]=`*(self: Element; attribute: ElementAttribute; value: int) =
  self.setAttribute(attribute, value)

func createDimensionAttribute*(width: int; height: int): string = fmt"{width}x{height}"