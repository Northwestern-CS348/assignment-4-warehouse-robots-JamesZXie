﻿(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )
   
   
   (:action robotMove
        :parameters (?l1 - location ?l2 - location ?r - robot)
        :precondition (and (at ?r ?l1) (no-robot ?l2) (free ?r) (connected ?l1 ?l2))
        :effect (and (no-robot ?l1) (at ?r ?l2)
                (not (no-robot ?l2)) (not (at ?r ?l1)))
   )
   
   (:action robotMoveWithPallate
        :parameters (?r - robot ?l1 - location ?l2 - location ?p - pallette)
        :precondition (and (at ?r ?l1) (no-robot ?l2) (at ?p ?l1) (free ?r) (connected ?l1 ?l2))
        :effect (and (no-robot ?l1) (at ?r ?l2) (at ?p ?l2) (has ?r ?p)
                (not (no-robot ?l2)) (not (at ?r ?l1)) (not (at ?p ?l1)))
   )
   
   (:action moveItemFromPalletteToShipment
        :parameters (?l - location ?s - shipment ?si - saleitem ?p - pallette ?o - order)
        :precondition (and (packing-at ?s ?l) (at ?p ?l) (started ?s) (ships ?s ?o) (orders ?o ?si) (contains ?p ?si))
        :effect (and (includes ?s ?si)
                (not (contains ?p ?si)))
   )
   
   (:action completeShipment
        :parameters (?s - shipment ?o - order ?l - location)
        :precondition (and (started ?s) (ships ?s ?o))
        :effect (and (complete ?s)
                (not (started ?s)))
   )

)
