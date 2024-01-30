# Stage 1: Build Stage
FROM node:14 as builder

# 작업 폴더를 만들고 npm 설치
RUN mkdir /usr/src/app
WORKDIR /usr/src/app
ENV PATH /usr/src/app/node_modules/.bin:$PATH
COPY package.json /usr/src/app/package.json

# 패키지 설치
RUN npm install

# react-scripts 설치
RUN npm install react-scripts -g

# 변경: npm run build 스크립트 실행 권한 설정
RUN chmod +x ./node_modules/.bin/react-scripts

# 패키지 설치 후에 build 스크립트를 실행
RUN npm run build

# Stage 2: Production Stage
FROM nginx:1.19

# Nginx의 기본 설정 삭제
RUN rm -rf /etc/nginx/conf.d

# Nginx 설정 파일 복사
COPY conf /etc/nginx

# 빌드된 앱 파일을 Nginx의 정적 파일 서빙 경로로 복사
COPY --from=builder /usr/src/app/build /usr/share/nginx/html

# 80포트 열기
EXPOSE 80

# Nginx 실행
CMD ["nginx", "-g", "daemon off;"]
