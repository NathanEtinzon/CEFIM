# Palo-Alto concise documentation

## Installation

- Device
    - Setup
        - Interfaces
        - Services (DNS)  
    - Licences
    - Dynamic updates

- Network
    - Interfaces WAN/LAN *(don't forget to add the interfaces on the vm in the hypervisor)*
    - Virtual routers *(default gateway)*

### *Optional*
- Network
    - Interface Management *(to ping interfaces)*

---

## URL Filtering & Antivirus

- Device
    - Certificates => Generate *(Forward Trust Certificate)*
    - Certificate Profile
    - Export certificate and install on client(s)

- Objects
    - Antivirus

- Policies
    - Decryption
    - Security
        - HTTP rule => Action => Profile setting => Antivirus profile

- Objects
    - URL categories *(for custom URL filtering)*
    - URL Filtering

- Policies
    - Security
        - SSL rule => Action => Profile setting => URL profile

---

## IPSec tunnel site to site

- Network
    - Interfaces tunnel
    - IKE crypto
    - IKE Gateway
    - IPSec crypto
    - IPSec tunnel *(check Proxys)*
    - Virtual router *(static route)*

- Policies
    - Security => IPSec/IKE rules

---

## Captive Portal

- Network
    - Zones => Select zone => Enable user identification
    - Interface => Select interface => Advanced Tab => Create Management interface profile

- Device
    - Users => Add User/User group
    - Certificates => Generate *(Forward Trust Certificate)*
    - SSL/TLS Service Profile
    - Authentification profile
    - User identification => Captive portal 

- Policies
    - Authentification profile
    - Decryption
    - Security => Add DNS/Captive portal rule

- Device
    - Certificates => Export certificate and install on client(s)