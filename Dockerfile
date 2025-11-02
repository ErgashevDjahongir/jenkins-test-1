# Oddiy, kichik nginx image bilan statik sayt uchun
FROM nginx:alpine

# Default nginx konfiguratsiyasidagi html papkaga nusxa
COPY app/index.html /usr/share/nginx/html/index.html

# Agar siz boshqa fayllar qo'ssangiz:
# COPY app /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
