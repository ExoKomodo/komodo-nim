type
    Component* = ref object of RootObj
        enabled: bool
        initialized: bool

func `isEnabled=`*(self: Component; value: bool) {.inline.} = self.enabled = value
func isEnabled*(self: Component): bool {.inline.} = self.enabled

func isInitialized*(self: Component): bool {.inline.} = self.initialized

method initialize*(self: Component) {.base.} =
    if not self.isInitialized:
        self.initialized = true
