# ActionItem Coordination Network

A blockchain-based smart contract system for organizing time-sensitive activities, supporting priority management, delegation, and deadline tracking.  
This project helps users efficiently coordinate their workflows in a decentralized, trustless environment.

---

## 📚 Overview

**ActionItem Coordination Network** enables users to:
- Register and manage personal activities.
- Assign deadlines and receive alerts.
- Set activity priorities (low, medium, high).
- Delegate tasks to other users.
- Track activity completion status.
- Modify or cancel activities.

All operations are performed securely on the blockchain, ensuring transparency and immutability.

---

## 🛠️ Smart Contract Features

- **Activity Registration**: Users can register new activities with descriptions.
- **Priority Management**: Classify activities into three priority levels.
- **Deadline Tracking**: Set blockchain height-based deadlines and monitor completion.
- **Activity Updates**: Modify existing activities and mark them as completed.
- **Collaboration**: Assign activities to other principals (users).
- **Validation Functions**: Verify the existence and status of activities without modifying state.

---

## 📂 Data Structures

| Structure | Purpose |
|-----------|---------|
| `activity-register` | Core activity details (description, completion status). |
| `activity-priority` | Priority level of activities (1 = low, 2 = medium, 3 = high). |
| `activity-deadlines` | Expected completion heights and alert triggers. |

---

## 🚀 Functions

| Type | Function | Description |
|------|----------|-------------|
| Public | `register-activity` | Register a new activity. |
| Public | `establish-deadline` | Set a deadline for the activity. |
| Public | `assign-priority` | Assign a priority level. |
| Public | `modify-activity` | Update description and/or status. |
| Public | `cancel-activity` | Remove an activity from the register. |
| Public | `assign-activity` | Assign activity to another user. |
| Public | `check-activity-existence` | Verify if the activity exists. |
| Read-Only | `get-activity-details` | Retrieve activity details. |
| Read-Only | `verify-activity-completion` | Check if the activity is complete. |

---

## 📜 Response Codes

| Code | Meaning |
|------|---------|
| `u400` | Invalid input error |
| `u404` | Activity not found |
| `u409` | Conflict error (e.g., trying to register an already existing activity) |

---

## 🧩 Requirements

- Clarity smart contract environment (e.g., [Clarinet](https://docs.stacks.co/docs/clarinet/overview/) for local development).
- Stacks blockchain or compatible Clarity network.

---

## ⚙️ Deployment

To deploy the contract:
```bash
clarinet deploy
```
Or use your preferred deployment tool compatible with Clarity smart contracts.

---

## 📄 License

This project is licensed under the MIT License. See [LICENSE](./LICENSE) for details.

---

## 🤝 Contributing

Contributions, suggestions, and improvements are welcome!  
Please open an issue or submit a pull request.

---

## ✨ Acknowledgments

Built for seamless task management in decentralized environments.

---
