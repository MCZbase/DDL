
   CREATE JAVA SOURCE NAMED "MCZBASE"."UUIDGen" AS 
 import java.util.UUID;public class UUIDGen {    public static String randomUUID() {        return UUID.randomUUID().toString();    }}