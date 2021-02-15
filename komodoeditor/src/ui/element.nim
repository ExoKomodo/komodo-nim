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
  AlignmentAttribute* = "ALIGNMENT".ElementAttribute
  GapAttribute* = "GAP".ElementAttribute
  MarginAttribute* = "MARGIN".ElementAttribute
  TitleAttribute* = "TITLE".ElementAttribute

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

func getAttribute*[T: Element](self: T; attribute: ElementAttribute): cstring =
  self.inner.getAttribute(attribute.cstring)

func setAttribute*[T: Element](self: T; attribute: ElementAttribute; value: string) =
  self.inner.setAttribute(attribute.cstring, value)

func setAttribute*[T: Element](self: T; attribute: ElementAttribute; value: int) =
  self.inner.setAttribute(attribute.cstring, $value)

func `[]=`*(self: Element; attribute: ElementAttribute; value: string) =
  self.setAttribute(attribute, value)

func `[]=`*(self: Element; attribute: ElementAttribute; value: int) =
  self.setAttribute(attribute, value)

func `[]`*(self: Element; attribute: ElementAttribute): cstring =
  self.getAttribute(attribute)

func createDimensionAttribute*(width: int; height: int): string = fmt"{width}x{height}"