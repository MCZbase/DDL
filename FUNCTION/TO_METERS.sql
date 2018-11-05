
  CREATE OR REPLACE FUNCTION "TO_METERS" (meas IN number, unit in varchar2 )
    return number DETERMINISTIC
-- Given a number and a unit with dimension length, return the number converted to a length in meters.    
-- Accepts values for unit in the form of an abbreviation, the singular unit name, or the plural unit name,
-- for example, Ft, Feet, and Foot are all used for feet to meters conversion.
-- A value of unit of MWO is understood as meaning meters.   Currently, meters, feet, kilometers, centimeters,
--  miles, yards, and fathoms are supported.
-- @param meas the number to convert to a length in meters.
-- @param unit the length unit (case insensitive) for the number to convert from.
-- @return a length in meters, or null (if meas is null, or unit is null, or unit is not known).
-- @see MCZBASE.update_flat
    as
        in_m  number;
	begin
	if meas is null or unit is null then
		in_m := null;
	else
		if upper(unit) = 'M' OR upper(unit) = 'METERS' OR upper(unit) = 'METER' OR upper(unit) = 'MWO' then
			in_m := meas;
		elsif upper(unit) = 'FT' OR upper(unit) = 'FEET' OR upper(unit) = 'FOOT' then
			in_m := meas * .3048;
		elsif upper(unit) = 'KM' OR upper(unit) = 'KILOMETER' OR upper(unit) = 'KILOMETERS' then
			in_m := meas * 1000;
    elsif upper(unit) = 'CM' OR upper(unit) = 'CENTIMETER' OR upper(unit) = 'CENTIMETERS' then
			in_m := meas / 100;      
		elsif upper(unit) = 'MI' OR upper(unit) = 'MILE' OR upper(unit) = 'MILES' then
			in_m := meas * 1609.344;
		elsif upper(unit) = 'YD' OR upper(unit) = 'YARD' OR upper(unit) = 'YARDS' then
			in_m := meas * .9144;
		elsif upper(unit) = 'FM' OR upper(unit) = 'FATHOM' OR upper(unit) = 'FATHOMS' OR upper(UNIT) = 'FMS' then
			in_m := meas * 1.8288;
    elsif upper(unit) = 'IN' then
			in_m := meas * 0.0254;
		else
			in_m := null;
		end if;
	end if;

	return in_m;
  end;
  --create public synonym to_meters for to_meters;
  --grant execute on to_meters to public;