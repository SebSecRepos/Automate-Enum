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

![imagen](https://github.com/user-attachments/assets/8d95f306-393c-4d14-b873-1e1120a7fe0f)


![imagen](https://github.com/user-attachments/assets/9d5ff15e-914b-48ca-bd3c-6ab90c467245)


-----

#### Example of passive subdomain enumeration using subfinder & assetfinder

```bash
ae dm -d google.com
```

![imagen](https://github.com/user-attachments/assets/886406e6-6959-42ce-8b8d-51fedf424aa8)


#### Example of automate axfr attack using domain/subdomain wordlist & automate DNS Enumeration
> All results will be saved in *./DNS_ENUM/domain/DNS_lookup*  && *./DNS_ENUM/domain/authoritative_victim_dns*

```bash
ae dnsa -d ./DOMAINS/google.com_subdomains
```

#### Obtain just success axfr results (Image doesn't show google domains axfr attack result)

```bash
ae axfr
```

![imagen](https://github.com/user-attachments/assets/0c74d64a-bf7e-4014-b8d3-83667cc1f28f)

