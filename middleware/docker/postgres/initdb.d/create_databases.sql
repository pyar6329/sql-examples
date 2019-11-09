CREATE DATABASE address;

CREATE TABLE IF NOT EXISTS "public"."latitude_longitudes" (
    "id" SERIAL NOT NULL,
    "prefecture" VARCHAR(255) NOT NULL DEFAULT '',
    "city" VARCHAR(255) NOT NULL DEFAULT '',
    "address" VARCHAR(255) NOT NULL DEFAULT '',
    "full_address" VARCHAR(255) NOT NULL DEFAULT '',
    "latitude" NUMERIC NOT NULL,
    "longitude" NUMERIC NOT NULL,
    PRIMARY KEY ("id")
);

-- CREATE INDEX latitude_longitudes_full_address_index ON latitude_longitudes (full_address);
--
CREATE TABLE IF NOT EXISTS "public"."zip_codes" (
    "id" SERIAL NOT NULL,
    "zip_code1" VARCHAR(255) NOT NULL,
    "zip_code2" VARCHAR(255) NOT NULL,
    "prefecture" VARCHAR(255) NOT NULL DEFAULT '',
    "city" VARCHAR(255) NOT NULL DEFAULT '',
    "address" VARCHAR(255),
    "full_address" VARCHAR(255) NOT NULL DEFAULT '',
    PRIMARY KEY ("id")
);

-- CREATE INDEX zip_codes_full_address_index ON zip_codes (full_address);

-- UPDATE zip_codes
-- SET address = ''
-- WHERE address is NULL;
