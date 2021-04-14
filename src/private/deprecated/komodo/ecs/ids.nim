import hashes
import oids


type ComponentId* = distinct Oid

func hash*(id: ComponentId): Hash = id.Oid.hash()
func `==`*(left: ComponentId, right: ComponentId): bool =
  left.Oid == right.Oid
proc nextComponentId*(): ComponentId = genOid().ComponentId


type EntityId* = distinct Oid

func hash*(id: EntityId): Hash = id.Oid.hash()
func `==`*(left: EntityId, right: EntityId): bool =
  left.Oid == right.Oid


proc nextEntityId*(): EntityId = genOid().EntityId
