extension Set {
    /// A writable membership flag, so a `Toggle` can bind straight to `$set[contains: element]`.
    subscript(contains element: Element) -> Bool {
        get { contains(element) }
        set {
            if newValue {
                insert(element)
            } else {
                remove(element)
            }
        }
    }
}
