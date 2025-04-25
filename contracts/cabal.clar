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

(define-constant ERROR-INVALID-INPUT (err u503))
(define-constant ERROR-PERMISSION-DENIED (err u504))

;; Administrative Configuration
(define-constant CONTRACT-SUPERVISOR tx-sender)

;; -----------------------------------------------
;; SECTION 2: DATA STORAGE
;; -----------------------------------------------

;; Tracks the total number of records in the directory
(define-data-var directory-counter uint u0)

;; Primary Directory Storage
(define-map village-directory
  { record-number: uint }
  {
    name: (string-ascii 50),
    steward: principal,
    registration-block: uint,
    bio: (string-ascii 160),
    categories: (list 5 (string-ascii 30))
  }
)

;; Authorization Management System
(define-map viewing-rights
  { record-number: uint, viewer: principal }
  { can-view: bool }
)

;; -----------------------------------------------
;; SECTION 3: HELPER FUNCTIONS
;; -----------------------------------------------

;; Verify record existence in directory
(define-private (record-exists? (record-number uint))
  (is-some (map-get? village-directory { record-number: record-number }))
)

;; Check if caller owns the specified record
(define-private (is-record-steward? (record-number uint) (principal-key principal))
  (match (map-get? village-directory { record-number: record-number })
    record-data (is-eq (get steward record-data) principal-key)
    false
  )
)

;; Category format validation
(define-private (is-valid-category-format? (category (string-ascii 30)))
  (and
    (> (len category) u0)
    (< (len category) u31)
  )
)

;; Validate the complete set of categories
(define-private (validate-categories (categories (list 5 (string-ascii 30))))
  (and
    (> (len categories) u0)
    (<= (len categories) u5)
    (is-eq (len (filter is-valid-category-format? categories)) (len categories))
  )
)

;; -----------------------------------------------
;; SECTION 4: PUBLIC INTERFACE FUNCTIONS
;; -----------------------------------------------

;; Register a new community member record
(define-public (register-new-member 
    (name (string-ascii 50)) 
    (bio (string-ascii 160)) 
    (categories (list 5 (string-ascii 30))))
  (let
    (
      (next-record-id (+ (var-get directory-counter) u1))
    )
    ;; Input validation checks
    (asserts! (and (> (len name) u0) (< (len name) u51)) ERROR-INVALID-INPUT)
    (asserts! (and (> (len bio) u0) (< (len bio) u161)) ERROR-INVALID-INPUT)
    (asserts! (validate-categories categories) ERROR-INVALID-INPUT)

    ;; Store the new member data
    (map-insert village-directory
      { record-number: next-record-id }
      {
        name: name,
        steward: tx-sender,
        registration-block: block-height,
        bio: bio,
        categories: categories
      }
    )

    ;; Set up initial viewing permissions
    (map-insert viewing-rights
      { record-number: next-record-id, viewer: tx-sender }
      { can-view: true }
    )

    ;; Update the directory size counter
    (var-set directory-counter next-record-id)

    ;; Return the new record identifier
    (ok next-record-id)
  )
)

;; Update an existing member's biography
(define-public (update-member-bio (record-number uint) (new-bio (string-ascii 160)))
  (let
    (
      (member-data (unwrap! (map-get? village-directory { record-number: record-number }) ERROR-RECORD-NOT-FOUND))
    )
    ;; Authentication and validation
    (asserts! (record-exists? record-number) ERROR-RECORD-NOT-FOUND)
    (asserts! (is-eq (get steward member-data) tx-sender) ERROR-PERMISSION-DENIED)
    (asserts! (< (len new-bio) u161) ERROR-INVALID-INPUT)

    ;; Update the biography field
    (map-set village-directory
      { record-number: record-number }
      (merge member-data { bio: new-bio })
    )

    ;; Return success
    (ok true)
  )
)

;; Update a member's category classifications
(define-public (update-member-categories (record-number uint) (new-categories (list 5 (string-ascii 30))))
  (let
    (
      (member-data (unwrap! (map-get? village-directory { record-number: record-number }) ERROR-RECORD-NOT-FOUND))
    )
    ;; Authentication and validation
    (asserts! (record-exists? record-number) ERROR-RECORD-NOT-FOUND)
    (asserts! (is-eq (get steward member-data) tx-sender) ERROR-PERMISSION-DENIED)
    (asserts! (validate-categories new-categories) ERROR-INVALID-INPUT)

    ;; Update the categories field
    (map-set village-directory
      { record-number: record-number }
      (merge member-data { categories: new-categories })
    )

    ;; Return success
    (ok true)
  )
)

;; Remove a member from the directory
(define-public (remove-member (record-number uint))
  (let
    (
      (member-data (unwrap! (map-get? village-directory { record-number: record-number }) ERROR-RECORD-NOT-FOUND))
    )
    ;; Authentication and validation
    (asserts! (record-exists? record-number) ERROR-RECORD-NOT-FOUND)
    (asserts! (is-eq (get steward member-data) tx-sender) ERROR-PERMISSION-DENIED)

    ;; Delete the member record from directory
    (map-delete village-directory { record-number: record-number })

    ;; Return success
    (ok true)
  )
)


