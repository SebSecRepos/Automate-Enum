# Automate-Enum

- URL & Subdomain enumeration
- Automate AXFR Attacks

-----


## Install
```bash
git clone https://github.com/SebSecRepos/Automate-Enum.git
cd Automate-Enum
sudo ./installer.sh
```


## Usage
```bash
ae <module> <option>  
```

![imagen](https://github.com/user-attachments/assets/2f2d381c-8595-4ef4-9ce0-136f35a061f8)

![imagen](https://github.com/user-attachments/assets/b42163f2-7a01-4db1-809a-b8ef703d2b26)

-----

#### Example passive subdomain enumeration using subfinder & assetfinder

```bash
ae dm -d google.com
```

![imagen](https://github.com/user-attachments/assets/886406e6-6959-42ce-8b8d-51fedf424aa8)


#### Example automate axfr attack using domain/subdomain wordlist & automate DNS Enumeration
> All results will be saved in *./DNS_ENUM/domain/DNS_lookup*  && *./DNS_ENUM/domain/authoritative_victim_dns*

```bash
ae dnsa -d ./DOMAINS/google.com_subdomains
```

#### Obtain just success axfr results (Image doesn't show google domains axfr attack result)

```bash
ae axfr
```

![imagen](https://github.com/user-attachments/assets/0c74d64a-bf7e-4014-b8d3-83667cc1f28f)

