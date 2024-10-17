#!/bin/bash

# 환경 변수 설정
export WORK="/root/popp-to-the-moon-bot"
export NVM_DIR="$HOME/.nvm"

# 색상 정의
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # 색상 초기화

echo -e "${GREEN}Tothemoon 봇을 설치합니다.${NC}"
echo -e "${GREEN}스크립트작성자: https://t.me/kjkresearch${NC}"
echo -e "${GREEN}출처: https://github.com/Widiskel/popp-to-the-moon-bot${NC}"

echo -e "${GREEN}설치 옵션을 선택하세요:${NC}"
echo -e "${YELLOW}1. 봇 새로 설치${NC}"
echo -e "${YELLOW}2. 기존정보 그대로 이용하기(재실행)${NC}"
read -p "선택: " choice

case $choice in
  1)
    echo -e "${GREEN}Tothemoon 봇을 새로 설치합니다.${NC}"

    # 사전 필수 패키지 설치
    echo -e "${YELLOW}시스템 업데이트 및 필수 패키지 설치 중...${NC}"
    sudo apt update
    sudo apt install -y git

    echo -e "${YELLOW}작업 공간 준비 중...${NC}"
    if [ -d "$WORK" ]; then
        echo -e "${YELLOW}기존 작업 공간 삭제 중...${NC}"
        rm -rf "$WORK"
    fi

    # GitHub에서 코드 복사
    echo -e "${YELLOW}GitHub에서 코드 복사 중...${NC}"
    git clone https://github.com/Widiskel/popp-to-the-moon-bot.git
    cd "$WORK"

    # Node.js LTS 버전 설치 및 사용
    echo -e "${YELLOW}Node.js LTS 버전을 설치하고 설정 중...${NC}"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # nvm을 로드합니다
    nvm install --lts
    nvm use --lts
    npm install

    echo -e "${YELLOW}Web텔레그렘에 접속후 F12를 누르시고 게임을 실행하세요${NC}"
    read -p "애플리케이션-세션저장소-Birds와 관련된 URL클릭 후 나오는 UserID나 QueryID를 적어두세요 (엔터) : "
    echo -e "${GREEN}다계정의 query_id를 입력할 경우 줄바꿈으로 구분하세요.${NC}"
    echo -e "${GREEN}입력을 마치려면 엔터를 두 번 누르세요.${NC}"
    echo -e "${YELLOW}query_id를 입력하세요:${NC}"
    
    # 쿼리 파일 생성 및 초기화
    {
        echo '[{' > "$WORK/src/config.json"  # 시작 JSON 형식 추가
        while true; do
            read -p "query_id를 입력하세요 (엔터로 종료): " line
            [[ -z "$line" ]] && break  # 빈 줄이면 종료
            echo "  \"token\": \"$line\"," >> "$WORK/src/config.json"  # 각 줄을 JSON 형식으로 추가
        done
        # 마지막 쉼표 제거
        sed -i '$ s/,$//' "$WORK/src/config.json"
        echo '}]' >> "$WORK/src/config.json"  # 종료 JSON 형식 추가
    }
    
    # 봇 구동
    node index.js
    ;;
    
  2)
    echo -e "${GREEN}Tothemoon 봇을 재실행합니다.${NC}"
    
    cd "$WORK"
    node index.js  
    ;;

  *)
    echo -e "${RED}잘못된 선택입니다. 다시 시도하세요.${NC}"
    ;;
esac
