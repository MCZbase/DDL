
  CREATE OR REPLACE PROCEDURE "MOVE_CONTAINERS" as

cursor c1 is select container_id, barcode 
  from container 
    where to_number(replace(barcode, 'PLACE', '')) <= 114
    and container_type = 'freezer rack' 
    order by to_number(replace(barcode, 'PLACE', ''));

i number;   
ContainerNum number;

begin
ContainerNum := 1741;
for c1_rec in c1 loop
  For i in 0..12 loop
  update container set parent_container_id = c1_rec.container_id where to_number(replace(barcode, 'PLACE', ''))=ContainerNum and container_type = 'rack slot';
  ContainerNum := ContainerNum + 1;
  end loop;
end loop;
end;
 