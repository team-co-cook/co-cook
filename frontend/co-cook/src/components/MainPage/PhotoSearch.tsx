import styled from "styled-components";
import { useInView } from "react-intersection-observer";
import Mockup from "../common/Mockup";
import cameraSearch from "@/videos/cameraSearch.mp4";
import { useEffect, useState } from "react";
import cocookLens from "@/image/cocookLens.png";

function PhotoSearch() {
  const { ref, inView, entry } = useInView({
    threshold: 0.8,
    triggerOnce: true,
  });

  const [scrollLocation, setScrollLocation] = useState<number>(0);

  const windowScrollListener = (e: Event) => {
    setScrollLocation((document.documentElement.scrollTop / 7 - 260) * -1);
  };

  useEffect(() => {
    window.addEventListener("scroll", windowScrollListener);
    return () => {
      window.removeEventListener("scroll", windowScrollListener);
    };
  }, []);

  return (
    <StyledPhotoSearch ref={ref} inView={inView}>
      <div>
        <div
          className="mockup"
          style={{
            transform: `translateY(${scrollLocation}px)`,
          }}
        >
          <Mockup isVideo={true} screen={cameraSearch} isRotate={false}></Mockup>
        </div>
        <div>
          <img src={cocookLens} alt="" />
          <h2>찰칵 찍어 레시피 확인</h2>
          <p>내 앞에 있는 음식의 레시피가 궁금하신가요?</p>
          <p>사진만 찍어보세요.</p>
        </div>
      </div>
    </StyledPhotoSearch>
  );
}

export default PhotoSearch;

const StyledPhotoSearch = styled.section<{ inView: boolean }>`
  @keyframes contentFade {
    0% {
      opacity: 0;
      transform: translateY(50px);
    }
    100% {
      opacity: 1;
      transform: translateY(0px);
    }
  }
  height: 600px;
  width: 100%;
  @media (max-width: 734px) {
    height: 700px;
  }
  & > div {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100%;
    width: 100%;
    @media (max-width: 734px) {
      flex-direction: column-reverse;
    }
    & > div {
      width: 50%;
      text-align: center;
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      @media (max-width: 734px) {
        width: 90%;
        height: 40%;
        margin-top: 24px;
      }
      & > img {
        width: 100px;
      }
      & > h2 {
        margin-block: 16px;
        word-break: keep-all;
        ${({ theme }) => theme.fontStyles.subtitle2}
        font-size: 2.5rem;
        line-height: 1.2;
        ${({ inView }) =>
          inView
            ? "animation: contentFade 0.5s ease-out;"
            : "opacity: 0; transform: translateY(50px);"}
        color: ${({ theme }) => theme.Colors.MONOTONE_BLACK};
      }
      & > p {
        word-break: keep-all;
        ${({ theme }) => theme.fontStyles.body1}
        font-size: 1rem;
        margin-bottom: 8px;
        color: ${({ theme }) => theme.Colors.MONOTONE_BLACK};
        ${({ inView }) =>
          inView
            ? "animation: contentFade 0.5s ease-out;"
            : "opacity: 0; transform: translateY(50px);"}
      }
    }
  }
  .mockup {
    display: flex;
    justify-content: center;
    @media (max-width: 734px) {
      width: 90%;
      height: 60%;
    }
  }
`;
