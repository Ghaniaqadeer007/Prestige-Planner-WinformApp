# Prestige Planners 📅✨

> A modern, robust desktop Event Management System designed to streamline client bookings, venue scheduling, vendor coordination, and billing with enterprise-grade data integrity.

---

## 📌 Overview

**Prestige Planners** is a full-featured Windows desktop application built with **C# Windows Forms** and styled using **Guna UI Framework** to deliver a sleek, contemporary user experience. Powered by **Microsoft SQL Server**, the platform centralizes end-to-end event planning operations—eliminating double-bookings, automating cost calculations, tracking vendor obligations, and maintaining an immutable audit history through database-level triggers and stored procedures.

---

## ✨ Key Features

* **Intuitive Modern Interface:** Built using Guna UI controls for animated transitions, customizable dark/light elements, and clean data grids.
* **Client & Booking Management:** Complete lifecycle handling for corporate galas, weddings, conferences, and private celebrations.
* **Venue & Calendar Scheduling:** Conflict detection to eliminate overlapping reservations and optimize hall allocations.
* **Vendor & Service Coordination:** Centralized tracking for caterers, decorators, audiovisual technicians, and entertainment providers.
* **Financial & Billing Automation:** Dynamic calculation of venue costs, package add-ons, taxes, advance deposits, and outstanding balances with receipt generation.
* **Enterprise Data Integrity & Auditing:** Automated database audit triggers that record creation, modifications, and deletion of critical records.
* **Stored Procedure Optimization:** Secure and high-performance database transactions protected against SQL injection.

---

## 🛠️ Tech Stack & Architecture

* **Language:** C# (.NET Framework)
* **UI Framework:** Windows Forms (WinForms) with **Guna UI** Controls
* **Database:** Microsoft SQL Server (T-SQL)
* **Data Access:** ADO.NET / Stored Procedures
* **Architecture Pattern:** Multi-tier Desktop Architecture (Presentation Layer $\to$ Business Logic $\to$ Data Access Layer)

---

## 🗄️ Database Architecture Highlights

The backend relies on structured T-SQL components designed for high concurrency and audit compliance:

* **Parameterized Stored Procedures:** Dedicated routines for booking creation, client registration, payment logging, and invoice generation.
* **Audit Triggers:** SQL Server triggers logging changes on sensitive tables (e.g., `Bookings`, `Payments`) into dedicated audit tables with timestamps and modified values.
* **Relational Integrity:** Foreign key constraints ensuring seamless referential integrity across Clients, Events, Venues, Vendors, and Invoices.

---

## 🚀 Getting Started

### Prerequisites

Ensure you have the following installed on your local development machine:

* **Operating System:** Windows 10 / 11
* **IDE:** [Visual Studio](https://visualstudio.microsoft.com/?utm_source=gemini) (2019, 2022, or newer) with the **.NET desktop development** workload installed
* **Database Engine:** [Microsoft SQL Server](https://www.microsoft.com/en-us/sql-server/?utm_source=gemini) (Developer / Express Edition)
* **Database GUI:** SQL Server Management Studio (SSMS)
* **UI Components:** Guna UI Framework library (DLL reference included in project dependencies)

---

### Installation & Setup

1. **Clone the repository:**
```bash
git clone https://github.com/your-username/prestige-planners.git
cd prestige-planners

```


2. **Set up the Database:**
* Launch **SQL Server Management Studio (SSMS)**.
* Open and execute the provided database setup script located at:
```text
database/schema.sql

```


* Run the stored procedures and triggers script:
```text
database/procedures_and_triggers.sql

```




3. **Configure Connection String:**
* Open `PrestigePlanners.sln` in **Visual Studio**.
* Navigate to `App.config` and update the connection string with your local SQL Server instance details:
```xml
<connectionStrings>
  <add name="PrestigePlannersDB" 
       connectionString="Server=YOUR_SERVER_NAME;Database=PrestigePlanners;Integrated Security=True;" 
       providerName="System.Data.SqlClient" />
</connectionStrings>

```




4. **Verify Guna UI References:**
* In Visual Studio Solution Explorer, ensure the `Guna.UI2.dll` reference is properly linked in the project references.


5. **Build and Run:**
* Set the build configuration to `Debug` or `Release`.
* Press `F5` or click **Start** to compile and run the application.



---

## 📂 Project Structure

```text
prestige-planners/
├── database/
│   ├── schema.sql                    # Table definitions, constraints, relationships
│   ├── procedures_and_triggers.sql   # Stored procedures and audit triggers
│   └── seed_data.sql                 # Sample test records (venues, services)
├── src/
│   ├── Presentation/                 # Windows Forms UI forms and dialogs
│   │   ├── MainForm.cs               # Central navigation dashboard
│   │   ├── BookingForm.cs            # Event reservation and scheduling form
│   │   ├── ClientForm.cs             # Client database management
│   │   └── BillingForm.cs            # Payment settlement and invoice UI
│   ├── BusinessLogic/                # Validation logic and calculation handlers
│   ├── DataAccess/                   # ADO.NET SQL helper and command execution
│   └── Models/                       # Entity data models (Client, Event, Venue, Payment)
├── assets/                           # Form icons, graphics, and theme assets
├── App.config                        # Application settings and DB connection string
├── PrestigePlanners.sln              # Visual Studio solution file
└── README.md

```

---

## 📸 Key Modules & Workflow

1. **Dashboard:** Real-time KPI cards displaying upcoming events, pending payments, and venue occupancy.
2. **Event Booking Wizard:** Interactive multi-step form to assign clients, select available halls, and configure package features.
3. **Vendor Management:** Keep track of external supplier contacts, contracted rates, and delivery schedules.
4. **Billing & Receipts:** Instant invoice generation with automated breakdown of deposits, tax rates, and final balances.

---

## 🤝 Contributing

Contributions, feedback, and feature requests are welcome!

1. Fork the Project.
2. Create your Feature Branch (`git checkout -b feature/NewFeature`).
3. Commit your Changes (`git commit -m 'Add NewFeature'`).
4. Push to the Branch (`git push origin feature/NewFeature`).
5. Open a Pull Request.

---

## 📄 License

Distributed under the **MIT License**. See `LICENSE` for more information.
