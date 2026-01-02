import swaggerJSDoc from "swagger-jsdoc";

const swaggerOptions = {
  definition: {
    openapi: "3.0.0",
    info: {
      title: "Product API",
      version: "1.0.0",
      description: "API quản lý sản phẩm (có upload ảnh)",
    },
    servers: [
      {
        url: "http://localhost:5000",
      },
    ],
  },
  apis: ["./routes/*.js"], // đọc comment trong routes
};

const swaggerSpec = swaggerJSDoc(swaggerOptions);

export default swaggerSpec;
