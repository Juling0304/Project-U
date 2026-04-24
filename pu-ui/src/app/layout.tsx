import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Project-U",
  description: "FastAPI + Next.js + LangGraph portfolio project",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="ko">
      <body>{children}</body>
    </html>
  );
}
