/**
 * ____________________________________________________________
 * 
 * ____________________________________________________________
 * 
 * @author Matej Đanić <matej.danic@triple-innovations.com>
 * @version 0.1
 * 
 * @created 21.5.2021.
 * ____________________________________________________________
 * 
*/

public with sharing class EnumUtil {
    public static Object parseEnum(string enumString, Type enumType) {
        Type cType = Type.forName(String.format('List<{0}>', new List<String>{ enumType.getName() }));
        return ((List<Object>) JSON.deserialize(String.format('["{0}"]', new List<String>{ enumString }), cType))[0];
    }
}