;; ActionItem Coordination Network
;;
;; A blockchain-based system for managing time-sensitive activities
;; with priority tracking and delegation capabilities.
;; This contract enables users to organize their workflow efficiently.


;; ============================================
;; PERSISTENT DATA STRUCTURES
;; ============================================

;; Collection of priority classifications for activities
;; Helps in organizing activities based on criticality
(define-map activity-priority
    principal
    {
        priority-level: uint
    }
)

;; Chronicle of temporal constraints for activities
;; Records expected completion timestamps and alert configurations
(define-map activity-deadlines
    principal
    {
        completion-height: uint,
        alert-triggered: bool
    }
)

;; Central registry of user activities and their statuses
;; Maps blockchain identities to their respective activity details
(define-map activity-register
    principal
    {
        activity-description: (string-ascii 100),
        activity-completed: bool
    }
)

;; ============================================
;; RESPONSE STATUS DEFINITIONS
;; ============================================
;; Standardized status codes for various operational scenarios
(define-constant NOT-FOUND-ERROR (err u404))
(define-constant CONFLICT-ERROR (err u409))
(define-constant INVALID-INPUT-ERROR (err u400))


;; ============================================
;; ACTIVITY INITIALIZATION FUNCTIONS
;; ============================================

;; Public function enabling users to register a new activity entry
(define-public (register-activity 
    (activity-description (string-ascii 100)))
    (let
        (
            (identity tx-sender)
            (existing-record (map-get? activity-register identity))
        )
        (if (is-none existing-record)
            (begin
                (if (is-eq activity-description "")
                    (err INVALID-INPUT-ERROR)
                    (begin
                        (map-set activity-register identity
                            {
                                activity-description: activity-description,
                                activity-completed: false
                            }
                        )
                        (ok "Activity successfully registered in system.")
                    )
                )
            )
            (err CONFLICT-ERROR)
        )
    )
)

;; ============================================
;; ACTIVITY MANAGEMENT EXTENSIONS
;; ============================================

;; Public function to establish activity time constraints
;; Sets a specific blockchain height target for completion
(define-public (establish-deadline (blocks-until-due uint))
    (let
        (
            (identity tx-sender)
            (existing-record (map-get? activity-register identity))
            (target-height (+ block-height blocks-until-due))
        )
        (if (is-some existing-record)
            (if (> blocks-until-due u0)
                (begin
                    (map-set activity-deadlines identity
                        {
                            completion-height: target-height,
                            alert-triggered: false
                        }
                    )
                    (ok "Activity deadline successfully established.")
                )
                (err INVALID-INPUT-ERROR)
            )
            (err NOT-FOUND-ERROR)
        )
    )
)

;; Public function to classify activity priority
;; Supports three-tier priority system (1=low, 2=medium, 3=high)
(define-public (assign-priority (priority-value uint))
    (let
        (
            (identity tx-sender)
            (existing-record (map-get? activity-register identity))
        )
        (if (is-some existing-record)
            (if (and (>= priority-value u1) (<= priority-value u3))
                (begin
                    (map-set activity-priority identity
                        {
                            priority-level: priority-value
                        }
                    )
                    (ok "Activity priority level successfully updated.")
                )
                (err INVALID-INPUT-ERROR)
            )
            (err NOT-FOUND-ERROR)
        )
    )
)


;; ============================================
;; ACTIVITY DISCOVERY FUNCTIONS
;; ============================================

;; Read-only function to retrieve comprehensive activity information
(define-read-only (get-activity-details (identity principal))
    (match (map-get? activity-register identity)
        entry (ok {
            activity-description: (get activity-description entry),
            activity-completed: (get activity-completed entry)
        })
        NOT-FOUND-ERROR
    )
)

;; Specialized function to check only completion status
(define-read-only (verify-activity-completion (identity principal))
    (match (map-get? activity-register identity)
        entry (ok (get activity-completed entry))
        NOT-FOUND-ERROR
    )
)

;; Public function for validation before operations
;; Allows clients to verify activity existence without modifying state
(define-public (check-activity-existence)
    (let
        (
            (identity tx-sender)
            (existing-record (map-get? activity-register identity))
        )
        (if (is-some existing-record)
            (let
                (
                    (current-record (unwrap! existing-record NOT-FOUND-ERROR))
                    (description-text (get activity-description current-record))
                    (completion-status (get activity-completed current-record))
                )
                (ok {
                    exists: true,
                    description-length: (len description-text),
                    is-complete: completion-status
                })
            )
            (ok {
                exists: false,
                description-length: u0,
                is-complete: false
            })
        )
    )
)


;; ============================================
;; ACTIVITY MODIFICATION FUNCTIONS
;; ============================================

;; Public function allowing users to update their existing activity
(define-public (modify-activity
    (activity-description (string-ascii 100))
    (activity-completed bool))
    (let
        (
            (identity tx-sender)
            (existing-record (map-get? activity-register identity))
        )
        (if (is-some existing-record)
            (begin
                (if (is-eq activity-description "")
                    (err INVALID-INPUT-ERROR)
                    (begin
                        (if (or (is-eq activity-completed true) (is-eq activity-completed false))
                            (begin
                                (map-set activity-register identity
                                    {
                                        activity-description: activity-description,
                                        activity-completed: activity-completed
                                    }
                                )
                                (ok "Activity successfully updated in system.")
                            )
                            (err INVALID-INPUT-ERROR)
                        )
                    )
                )
            )
            (err NOT-FOUND-ERROR)
        )
    )
)

;; Public function enabling users to remove their activity
(define-public (cancel-activity)
    (let
        (
            (identity tx-sender)
            (existing-record (map-get? activity-register identity))
        )
        (if (is-some existing-record)
            (begin
                (map-delete activity-register identity)
                (ok "Activity successfully removed from system.")
            )
            (err NOT-FOUND-ERROR)
        )
    )
)

;; ============================================
;; COLLABORATION MECHANISMS
;; ============================================

;; Public function enabling activity assignment to other users
;; Allows authorized users to create activities for others
(define-public (assign-activity
    (recipient-identity principal)
    (activity-description (string-ascii 100)))
    (let
        (
            (existing-record (map-get? activity-register recipient-identity))
        )
        (if (is-none existing-record)
            (begin
                (if (is-eq activity-description "")
                    (err INVALID-INPUT-ERROR)
                    (begin
                        (map-set activity-register recipient-identity
                            {
                                activity-description: activity-description,
                                activity-completed: false
                            }
                        )
                        (ok "Activity successfully assigned to recipient.")
                    )
                )
            )
            (err CONFLICT-ERROR)
        )
    )
)

