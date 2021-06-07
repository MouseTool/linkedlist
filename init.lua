--- Generic linked list implementation
--- @class LinkedList
--- @field protected _front LinkedListNode|nil @The front of the linked list
--- @field protected _back LinkedListNode|nil @The back of the linked list
--- @field public size number @The length of the linked list
local LinkedList = {}
LinkedList.__index = LinkedList

--- @class LinkedListNode
--- @field value any @The value of the node
--- @field next LinkedListNode|nil @The next linked node
--- @field prev LinkedListNode|nil @The previous linked node

--- Inserts an element to the beginning
--- @param value any Element value to insert
function LinkedList:push_back(value)
    --- @type LinkedListNode
    local node = {
        value = value,
        prev = self._back
    }
    if not self._front then
        self._front = node
    end
    if self._back then
        self._back.next = node
    end
    self._back = node
    self.size = self.size + 1
end

--- Adds an element to the end
--- @param value any Element value to insert
function LinkedList:push_front(value)
    --- @type LinkedListNode
    local node = {
        value = value,
        next = self._front
    }
    if not self._back then
        self._back = node
    end
    if self._front then
        self._front.prev = node
    end
    self._front = node
    self.size = self.size + 1
end

--- Inserts an element after the specified position
--- @param afterPosition number Index before which the content will be inserted
--- @param value any Element value to insert
--- @return boolean success
function LinkedList:insert_after(afterPosition, value)
    if afterPosition <= 0  or afterPosition > self.size then
        return true
    end
    local before_node = self._front
    for _ = 2, afterPosition do
        before_node = before_node.next
    end
    --- @type LinkedListNode
    local node = {
        value = value,
        prev = before_node,
        next = before_node.next,
    }
    before_node.next = node
    if node.next then
        node.next.prev = node
    else
        -- This node is the back
        self._back = node
    end
    self.size = self.size + 1
    return true
end

--- Removes an element at the specified position
--- @param position number Index at which the content will be removed
--- @return boolean success
function LinkedList:remove(position)
    if position <= 0  or position > self.size then
        return false
    end
    local target_node = self._front
    for _ = 2, position do
        target_node = target_node.next
    end
    if target_node.prev then
        target_node.prev.next = target_node.next
    else
        -- This node is the front
        self._front = target_node.next
    end
    if target_node.next then
        target_node.next.prev = target_node.prev
    else
        -- This node is the back
        self._back = target_node.prev
    end
    self.size = self.size - 1
    return true
end

--- Removes and retrieves the last element
--- @return any
function LinkedList:pop_back()
    local value = self._back.value
    self._back = self._back.prev
    if self._back then
        self._back.next = nil
    else
        self._front = nil
    end
    self.size = self.size - 1
    return value
end

--- Removes and retrieves the first element
--- @return any
function LinkedList:pop_front()
    local value = self._front.value
    self._front = self._front.next
    if self._front then
        self._front.prev = nil
    else
        self._back = nil
    end
    self.size = self.size - 1
    return value
end

--- Retrieves the last element
--- @return any
function LinkedList:back()
    return self._back.value
end

--- Retrieves the first element
--- @return any
function LinkedList:front()
    return self._front.value
end

--- Retreives the element at the specified position
--- @param position number Index of the element
--- @return any
function LinkedList:get(position)
    if position <= 0  or position > self.size then
        return nil
    end
    local node = self._front
    for _ = 2, position do
        node = node.next
    end
    return node.value
end

--- Returns an iterator for the linked list
--- @return fun(_: LinkedListNode, i?: integer):integer, any
--- @return LinkedListNode
--- @return integer i
function LinkedList:ipairs()
    local node = self._front
    local function iter(_, i)
        if not node then return nil end
        local val = node.value
        node = node.next
        return i + 1, val
    end
    return iter, node, 0
end

--- Returns an iterator for the linked list.
--- Similar to `ipairs()` but iterates in reverse (from back to front).
--- The index returned starts from the back instead of front.
--- @return fun(_: LinkedListNode, i?: integer):integer, any
--- @return LinkedListNode
--- @return integer i
function LinkedList:revipairs()
    local node = self._back
    local function iter(_, i)
        if not node then return nil end
        local val = node.value
        node = node.prev
        return i - 1, val
    end
    return iter, node, self.size + 1
end

--- Retrieves the elements in raw list form
--- @return any[]
function LinkedList:to_list()
    local node, ret, size = self._front, {}, 0
    while node do
        size = size + 1
        ret[size] = node.value
        node = node.next
    end
    return ret
end

--- Retrieves the elements reversed, in raw list form
--- @return any[]
function LinkedList:to_reversed_list()
    local node, ret, size = self._back, {}, 0
    while node do
        size = size + 1
        ret[size] = node.value
        node = node.prev
    end
    return ret
end

--- Constructs a new linked list
--- @param list any[]|nil
--- @return LinkedList
function LinkedList.new(list)
    --- @type LinkedList
    local ll = setmetatable({}, LinkedList)
    ll.size = 0
    if list then
        for i = 1, #list do
            ll:push_back(list[i])
        end
    end
    return ll
end

return LinkedList
