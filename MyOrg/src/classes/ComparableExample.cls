//Adds sorting support for Lists that contain non-primitive types, that is, Lists of user-defined types.
global class ComparableExample implements Comparable {
    //The implemented method must be declared as global or public.
    //compareTo(objectToCompareTo): Returns an Integer value that is the result of the comparison.
    /*
    The implementation of this method should return the following values:
    0 if this instance and objectToCompareTo are equal
    > 0 if this instance is greater than objectToCompareTo
    < 0 if this instance is less than objectToCompareTo
    */
    
    // Constructor
    public ComparableExample() {
        
    }
    
    // Implement the compareTo() method
    global Integer compareTo(Object compareTo) {
        return null;        
    }
}