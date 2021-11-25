const { HeroiSchema, sequelize } = require("./database");
const faker = require("faker");
const handler = async (event) => {
  try {
    await sequelize.authenticate();
    console.log("Connection has been established successfully!");
    await HeroiSchema.sync();
    const result = await HeroiSchema.create({
      nome: faker.name.title(),
      poder: faker.name.jobTitle(),
    });

    const all = await HeroiSchema.findAll({
      raw: true,
      attributes: ["nome", "poder", "id"],
    });

    return {
      body: JSON.stringify({
        result,
      }),
    };
  } catch (error) {
    console.log("Unable to connect to the database", error.stack);
    return {
      statusCode: 500,
      body: "ERRR",
    };
  }
};

exports.handler = handler;
