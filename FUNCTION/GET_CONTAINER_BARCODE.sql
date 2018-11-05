
  CREATE OR REPLACE FUNCTION "GET_CONTAINER_BARCODE" (containerId  in number )
    return varchar2
   as
   	barcode    varchar2(255);
   begin
   select barcode into barcode from container where container_id = containerId;
        return barcode;
  end;
 
 