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
