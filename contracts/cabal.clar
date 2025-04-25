;; ===============================================
;; CabalDirectory - A Decentralized Community Index
;; ===============================================
;; Version: 1.0.0
;; Purpose: Enables community members to register and manage 
;;          their digital presence in a decentralized directory

;; -----------------------------------------------
;; SECTION 1: CONSTANT DEFINITIONS
;; -----------------------------------------------

;; Result Status Codes for Operations
(define-constant ERROR-NOT-AUTHORIZED (err u500))
(define-constant ERROR-RECORD-NOT-FOUND (err u501))
(define-constant ERROR-RECORD-EXISTS (err u502))