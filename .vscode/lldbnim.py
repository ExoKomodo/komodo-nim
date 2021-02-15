import lldb

ERROR_STRING = '<error>'
NIM_ARRAY_MATCH = '^tyArray__.*$'
NIM_SEQUENCE_MATCH = '^tySequence__.*$'
NIM_STRING_MATCH = 'NimStringV2'
NIM_TABLE_MATCH = '^tyObject_Table__.*$'

def NimStringSummaryFormatter(valobj, internal_dict):
    result = ERROR_STRING
    try:
        valobj_data = valobj.GetNonSyntheticValue()
        
        pointer = valobj_data.GetChildMemberWithName('p')
        data = pointer.GetChildMemberWithName('data').AddressOf()
        data.SetFormat(lldb.eFormatCString)
        result = data.GetValue()
    except:
        pass
    return result

class NimSeqProvider:
    def __init__(self, valobj, dict):
        self.valobj = valobj

    def num_children(self):
        try:
            return self.length.GetValueAsUnsigned(0)
        except:
            return None

    def get_child_at_index(self, index):
        try:
            offset = index * self.data_size
            return self.start.CreateChildAtOffset(
                '[' + str(index) + ']',
                offset,
                self.data_type,
            )
        except:
            return None

    def get_child_index(self, name):
        try:
            return int(name.lstrip('[').rstrip(']'))
        except:
            return None

    def update(self):
        try:
            valobj_data = self.valobj.GetNonSyntheticValue()
            self.length = valobj_data.GetChildMemberWithName('len')
            
            pointer = valobj_data.GetChildMemberWithName('p')
            data = pointer.GetChildMemberWithName('data')
            self.start = data
            self.data_type = data.GetType().GetArrayElementType()
            self.data_size = self.data_type.GetByteSize()
        except:
            pass
    
    def has_children(self):
        return True

def NimSeqSummaryFormatter(valobj, internal_dict):
    result = ERROR_STRING
    try:
        valobj_data = valobj.GetNonSyntheticValue()
        length = valobj_data.GetChildMemberWithName('len')
        result = 'Sequence - { len=' + str(length.GetValueAsSigned()) + ' }'
    except:
        pass
    return result

def NimArraySummaryFormatter(valobj, internal_dict):
    result = ERROR_STRING
    try:
        array_type = valobj.GetType()
        element_type = array_type.GetArrayElementType()
        size = int(array_type.GetByteSize() / element_type.GetByteSize())
        result = 'Array - { size=' + str(size) + ' }'
    except:
        pass
    return result

class NimTableProvider:
    def __init__(self, valobj, dict):
        self.valobj = valobj

    def num_children(self):
        try:
            return len(self.array)
        except:
            return None

    def get_child_at_index(self, index):
        try:
            return self.array[index]
        except:
            return None

    def get_child_index(self, name):
        try:
            key = int(name.lstrip('[').rstrip(']'))
            return self.table.get(key)
        except:
            return None

    def num_elem_children(self):
        try:
            count = self.length.GetValueAsUnsigned(0)
            if count < 0 or count > 1000000:
                count = 0
            return count
        except:
            return None

    def get_elem_at_index(self, index):
        try:
            offset = index * self.data_size
            return self.start.CreateChildAtOffset(
                '[' + str(index) + ']',
                offset,
                self.data_type,
            )
        except:
            return None

    def update(self):
        try:
            seq = self.valobj.GetChildMemberWithName('data').GetNonSyntheticValue()
            self.length = seq.GetChildMemberWithName('len')
            
            pointer = seq.GetChildMemberWithName('p')
            data = pointer.GetChildMemberWithName('data')
            self.start = data
            self.data_type = data.GetType().GetArrayElementType()
            self.data_size = self.data_type.GetByteSize()
            
            count = self.num_elem_children()
            if count > 1000:
                count = 1000
            
            self.table = {}
            self.array = []
            for i in range(self.num_elem_children()):
                elem = self.get_elem_at_index(i)
                key_field = elem.GetChildMemberWithName('Field0')
                hashed_value = key_field.GetValueAsUnsigned()
                if hashed_value != 0:
                    key = str(hashed_value)
                    value_field = elem.GetChildMemberWithName('Field2')
                    value = value_field.CreateValueFromAddress(
                        key,
                        value_field.GetLoadAddress(),
                        value_field.GetType(),
                    )
                    self.table[key] = len(self.array)
                    self.array.append(value)
        except:
            pass
    
    def has_children(self):
        return True

def NimTableSummaryFormatter(valobj, internal_dict):
    result = ERROR_STRING
    try:
        valobj_data = valobj.GetNonSyntheticValue()
        length = valobj_data.GetChildMemberWithName('counter')
        result = 'Table - { len=' + str(length.GetValueAsSigned()) + ' }'
    except:
        pass
    return result

def __lldb_init_module(debugger, internal_dict):
    category = debugger.GetDefaultCategory()
    category.SetEnabled(True)

    category.AddTypeSummary(
        lldb.SBTypeNameSpecifier(NIM_STRING_MATCH),
        lldb.SBTypeSummary.CreateWithFunctionName('lldbnim.NimStringSummaryFormatter'),
    )

    category.AddTypeSynthetic(
        lldb.SBTypeNameSpecifier(NIM_SEQUENCE_MATCH, True),
        lldb.SBTypeSynthetic.CreateWithClassName(
            'lldbnim.NimSeqProvider',
            lldb.eTypeOptionCascade,
        ),
    )
    category.AddTypeSummary(
        lldb.SBTypeNameSpecifier(NIM_SEQUENCE_MATCH, True),
        lldb.SBTypeSummary.CreateWithFunctionName('lldbnim.NimSeqSummaryFormatter'),
    )

    category.AddTypeSummary(
        lldb.SBTypeNameSpecifier(NIM_ARRAY_MATCH, True),
        lldb.SBTypeSummary.CreateWithFunctionName('lldbnim.NimArraySummaryFormatter'),
    )

    category.AddTypeSynthetic(
        lldb.SBTypeNameSpecifier(NIM_TABLE_MATCH, True),
        lldb.SBTypeSynthetic.CreateWithClassName(
            'lldbnim.NimTableProvider',
            lldb.eTypeOptionCascade,
        ),
    )

    category.AddTypeSummary(
        lldb.SBTypeNameSpecifier(NIM_TABLE_MATCH, True),
        lldb.SBTypeSummary.CreateWithFunctionName('lldbnim.NimTableSummaryFormatter'),
    )
