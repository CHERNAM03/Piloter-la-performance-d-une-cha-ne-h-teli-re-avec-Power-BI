-- public.clients definition

-- Drop table

-- DROP TABLE public.clients;

CREATE TABLE public.clients (
	client_id serial4 NOT NULL,
	pays varchar(50) NULL,
	segment_client varchar(20) NOT NULL,
	date_inscription date NOT NULL,
	CONSTRAINT clients_client_id_not_null NOT NULL client_id,
	CONSTRAINT clients_date_inscription_not_null NOT NULL date_inscription,
	CONSTRAINT clients_pkey PRIMARY KEY (client_id),
	CONSTRAINT clients_segment_client_not_null NOT NULL segment_client
);


-- public.hotels definition

-- Drop table

-- DROP TABLE public.hotels;

CREATE TABLE public.hotels (
	hotel_id serial4 NOT NULL,
	nom_hotel varchar(100) NOT NULL,
	ville varchar(50) NOT NULL,
	categorie varchar(20) NOT NULL,
	nombre_chambres int4 NOT NULL,
	date_ouverture date NOT NULL,
	CONSTRAINT hotels_categorie_not_null NOT NULL categorie,
	CONSTRAINT hotels_date_ouverture_not_null NOT NULL date_ouverture,
	CONSTRAINT hotels_hotel_id_not_null NOT NULL hotel_id,
	CONSTRAINT hotels_nom_hotel_not_null NOT NULL nom_hotel,
	CONSTRAINT hotels_nombre_chambres_not_null NOT NULL nombre_chambres,
	CONSTRAINT hotels_pkey PRIMARY KEY (hotel_id),
	CONSTRAINT hotels_ville_not_null NOT NULL ville
);


-- public.chambres definition

-- Drop table

-- DROP TABLE public.chambres;

CREATE TABLE public.chambres (
	chambre_id serial4 NOT NULL,
	hotel_id int4 NOT NULL,
	type_chambre varchar(20) NOT NULL,
	capacite int4 NOT NULL,
	tarif_standard numeric(8, 2) NOT NULL,
	CONSTRAINT chambres_capacite_not_null NOT NULL capacite,
	CONSTRAINT chambres_chambre_id_not_null NOT NULL chambre_id,
	CONSTRAINT chambres_hotel_id_not_null NOT NULL hotel_id,
	CONSTRAINT chambres_pkey PRIMARY KEY (chambre_id),
	CONSTRAINT chambres_tarif_standard_not_null NOT NULL tarif_standard,
	CONSTRAINT chambres_type_chambre_not_null NOT NULL type_chambre,
	CONSTRAINT chambres_hotel_id_fkey FOREIGN KEY (hotel_id) REFERENCES public.hotels(hotel_id)
);


-- public.reservations definition

-- Drop table

-- DROP TABLE public.reservations;

CREATE TABLE public.reservations (
	reservation_id serial4 NOT NULL,
	client_id int4 NOT NULL,
	chambre_id int4 NOT NULL,
	date_reservation date NOT NULL,
	date_arrivee date NOT NULL,
	date_depart date NOT NULL,
	statut varchar(20) NOT NULL,
	canal_reservation varchar(30) NOT NULL,
	montant_total numeric(10, 2) NULL,
	CONSTRAINT reservations_canal_reservation_not_null NOT NULL canal_reservation,
	CONSTRAINT reservations_chambre_id_not_null NOT NULL chambre_id,
	CONSTRAINT reservations_client_id_not_null NOT NULL client_id,
	CONSTRAINT reservations_date_arrivee_not_null NOT NULL date_arrivee,
	CONSTRAINT reservations_date_depart_not_null NOT NULL date_depart,
	CONSTRAINT reservations_date_reservation_not_null NOT NULL date_reservation,
	CONSTRAINT reservations_pkey PRIMARY KEY (reservation_id),
	CONSTRAINT reservations_reservation_id_not_null NOT NULL reservation_id,
	CONSTRAINT reservations_statut_not_null NOT NULL statut,
	CONSTRAINT reservations_chambre_id_fkey FOREIGN KEY (chambre_id) REFERENCES public.chambres(chambre_id),
	CONSTRAINT reservations_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(client_id)
);